From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Wed, 01 Aug 2007 23:40:14 +0900 (JST)
Message-ID: <200708011440.l71EeFAA029056@toshiba.co.jp>
References: <Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
	<200707310025.l6V0PDOP029552@toshiba.co.jp>
	<Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Jan Engelhardt <jengelh@computergmbh.de>

> 
> On Jul 31 2007 09:25, Yasuyuki KOZAKAI wrote:
> >> +		snprintf(path, sizeof(path), "%s/lib%s_%s.so", lib_dir,
> >> +		         family_prefix[AF_UNSPEC], name);
> >
> >So, here "%s/libxt_%s.so" is enough, and
> >
> >> +		if (ptr == NULL && family < ARRAY_SIZE(family_prefix) &&
> >> +		    family_prefix[family] != NULL) {
> >> +			snprintf(path, sizeof(path), "%s/lib%s_%s.so",
> >> +			         lib_dir, family_prefix[family], name);
> >
> >let's use afinfo.libprefix.
> >



>  struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
> -				 struct xtables_rule_match **matches)
> +				 struct xtables_rule_match **matches,
> +				 unsigned int family)
>  {
>  	struct xtables_match *ptr;
>  	const char *icmp6 = "icmp6";
> @@ -292,21 +294,25 @@ struct xtables_match *find_match(const c
>  	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
>  		char path[strlen(lib_dir) + sizeof("/.so")
>  			  + strlen(afinfo.libprefix) + strlen(name)];
> -		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
> -			name);
> -		if (dlopen(path, RTLD_NOW)) {
> -			/* Found library.  If it didn't register itself,
> -			   maybe they specified target as match. */
> -			ptr = find_match(name, DONT_LOAD, NULL);
> -
> -			if (!ptr)
> -				exit_error(PARAMETER_PROBLEM,
> -					   "Couldn't load match `%s'\n",
> -					   name);
> -		} else if (tryload == LOAD_MUST_SUCCEED)
> +
> +		snprintf(path, sizeof(path), "%s/libxt_%s.so", lib_dir, name);
> +		if (dlopen(path, RTLD_NOW) != NULL)
> +			/*
> +			 * Library loaded (and its constructors run).
> +			 * Try to grab the pointer to the struct.
> +			 */
> +			ptr = find_match(name, DONT_LOAD, NULL, family);
> +
> +		if (ptr == NULL) {
> +			snprintf(path, sizeof(path), "%s/%s%s.so",
> +			         lib_dir, afinfo.libprefix, name);
> +			if (dlopen(path, RTLD_NOW) != NULL)
> +				ptr = find_match(name, DONT_LOAD, NULL, family);
> +		}
> +
> +		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
>  			exit_error(PARAMETER_PROBLEM,
> -				   "Couldn't load match `%s':%s\n",
> -				   name, dlerror());
> +				   "Couldn't load match `%s'\n", name);
>  	}
>  #else
>  	if (ptr && !ptr->loaded) {

The argument 'family' has no effect. And this change makes possible to
remove links from libxt_*.so to libip[6]t_*.so as you proposed.

How about following ?


---
 extensions/Makefile |   12 ------------
 xtables.c           |   37 ++++++++++++++++++++++---------------
 2 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/extensions/Makefile b/extensions/Makefile
index 49e95ca..36c9b44 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -56,14 +56,12 @@ SHARED_LIBS+=$(foreach T,$(PF_EXT_SLIB),extensions/libipt_$(T).so)
 SHARED_SE_LIBS+=$(foreach T,$(PF_EXT_SE_SLIB),extensions/libipt_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
 
 ifeq ($(DO_IPV6), 1)
 SHARED_LIBS+=$(foreach T,$(PF6_EXT_SLIB),extensions/libip6t_$(T).so)
 SHARED_SE_LIBS+=$(foreach T,$(PF6_EXT_SE_SLIB),extensions/libip6t_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 EXTRA_INSTALLS+=$(foreach T, $(PF6_EXT_SE_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
-EXTRA_INSTALLS+=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
 endif
 
 SHARED_LIBS+=$(foreach T,$(PFX_EXT_SLIB),extensions/libxt_$(T).so)
@@ -192,16 +190,6 @@ extensions/libip6t_matches.man: $(patsubst %, extensions/libip6t_%.man, $(PF6_EX
 	    done ;\
        	fi >>extensions/libip6t_matches.man
 
-PF_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libipt_$(T).so)
-$(PF_XTLIBS): $(DEST_IPT_LIBDIR)/libipt_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
-	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	ln -sf $< $@
-
-PF6_XTLIBS=$(foreach T, $(PFX_EXT_SLIB), $(DEST_IPT_LIBDIR)/libip6t_$(T).so)
-$(PF6_XTLIBS): $(DEST_IPT_LIBDIR)/libip6t_%.so : $(DEST_IPT_LIBDIR)/libxt_%.so
-	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
-	ln -sf $< $@
-
 $(DEST_IPT_LIBDIR)/libipt_%.so: extensions/libipt_%.so
 	@[ -d $(DEST_IPT_LIBDIR)/ ] || mkdir -p $(DEST_IPT_LIBDIR)/
 	cp $< $@
diff --git a/xtables.c b/xtables.c
index baee483..58b4e81 100644
--- a/xtables.c
+++ b/xtables.c
@@ -292,18 +292,21 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/.so")
 			  + strlen(afinfo.libprefix) + strlen(name)];
-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
-			name);
-		if (dlopen(path, RTLD_NOW)) {
+
+		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
+		if (dlopen(path, RTLD_NOW) != NULL)
 			/* Found library.  If it didn't register itself,
 			   maybe they specified target as match. */
 			ptr = find_match(name, DONT_LOAD, NULL);
 
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load match `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
+		if (ptr == NULL) {
+			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
+				name);
+			if (dlopen(path, RTLD_NOW) != NULL)
+				ptr = find_match(name, DONT_LOAD, NULL);
+		}
+
+		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load match `%s':%s\n",
 				   name, dlerror());
@@ -362,16 +365,20 @@ struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/.so")
 			  + strlen(afinfo.libprefix) + strlen(name)];
-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix, name);
-		if (dlopen(path, RTLD_NOW)) {
+
+		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
+		if (dlopen(path, RTLD_NOW) != NULL)
 			/* Found library.  If it didn't register itself,
 			   maybe they specified match as a target. */
 			ptr = find_target(name, DONT_LOAD);
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load target `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
+
+		if (ptr == NULL) {
+			sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
+				name);
+			if (dlopen(path, RTLD_NOW) != NULL)
+				ptr = find_target(name, DONT_LOAD);
+		}
+		if (ptr == NULL && tryload == LOAD_MUST_SUCCEED)
 			exit_error(PARAMETER_PROBLEM,
 				   "Couldn't load target `%s':%s\n",
 				   name, dlerror());
-- 
1.5.2.2



-- Yasuyuki Kozakai
