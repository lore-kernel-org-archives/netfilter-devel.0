From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH] fixes libipt_geoip.c country check-up and print() output
Date: Mon, 15 Nov 2004 21:38:59 -0500
Message-ID: <41996843.8000500@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050204090809020602010106"
Cc: nib@cookinglinux.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------050204090809020602010106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi there,

I know that geoip isn't in the svn yet, but here's the patch anyway.
*For those who need it*

It removes useless static country check-up.
This wasn't smart as it prevents users from using newly-added
countries in the db. (and vice-versa)

Anyway, they will get warned if the country isn't in the database.

This patch also adds a trailing space for a correct --list output.

Nicolas, please rebuild a new package with this patch.

Thanks,

Samuel
CookingLinux TM

[diff -Nru -p1 geoip.orig/iptables/extensions/libipt_geoip.c 
geoip/iptables/extensions/libipt_geoip.c]

--------------050204090809020602010106
Content-Type: text/x-patch;
 name="libipt_geoip.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_geoip.c.patch"

--- geoip.orig/iptables/extensions/libipt_geoip.c	2004-11-07 11:08:42.000000000 -0500
+++ geoip/iptables/extensions/libipt_geoip.c	2004-11-15 21:14:06.000000000 -0500
@@ -27,28 +27,2 @@
 
-// We need it to verify inputed country code
-// This shouldn't go in ipt_geoip.h because only this library needs it.
-// Also, those country codes *MUST* stand in alphabetic order due to the
-// algorithm used to seek through this list.
-#define COUNTRYCOUNT    243      /* Always re-adjust this value when
-                                    adding/removing a country */
-#define COUNTRYCODESZ   2        // This value shouldn't be changed.
-static char *cc_list[COUNTRYCOUNT] = {
-"A1","A2", // Anonymous Proxies and Satellite Providers
-"AD","AE","AF","AG","AI","AL","AM","AN","AO","AQ","AR","AS","AT","AU","AW","AZ",
-"BA","BB","BD","BE","BF","BG","BH","BI","BJ","BM","BN","BO","BR","BS","BT","BV",
-"BW","BY","BZ","CA","CC","CD","CF","CG","CH","CI","CK","CL","CM","CN","CO","CR",
-"CU","CV","CX","CY","CZ","DE","DJ","DK","DM","DO","DZ","EC","EE","EG","EH","ER",
-"ES","ET","FI","FJ","FK","FM","FO","FR","FX","GA","GB","GD","GE","GF","GH","GI",
-"GL","GM","GN","GP","GQ","GR","GS","GT","GU","GW","GY","HK","HM","HN","HR","HT",
-"HU","ID","IE","IL","IN","IO","IQ","IR","IS","IT","JM","JO","JP","KE","KG","KH",
-"KI","KM","KN","KP","KR","KW","KY","KZ","LA","LB","LC","LI","LK","LR","LS","LT",
-"LU","LV","LY","MA","MC","MD","MG","MH","MK","ML","MM","MN","MO","MP","MQ","MR",
-"MS","MT","MU","MV","MW","MX","MY","MZ","NA","NC","NE","NF","NG","NI","NL","NO",
-"NP","NR","NU","NZ","OM","PA","PE","PF","PG","PH","PK","PL","PM","PN","PR","PS",
-"PT","PW","PY","QA","RE","RO","RU","RW","SA","SB","SC","SD","SE","SG","SH","SI",
-"SJ","SK","SL","SM","SN","SO","SR","ST","SV","SY","SZ","TC","TD","TF","TG","TH",
-"TJ","TK","TM","TN","TO","TP","TR","TT","TV","TW","TZ","UA","UG","UM","US","UY",
-"UZ","VA","VC","VE","VG","VI","VN","VU","WF","WS","YE","YT","YU","ZA","ZM","ZR",
-"ZW" };
-
 static void help(void)
@@ -90,16 +64,2 @@ static void geoip_free(struct geoip_info
 
-static u_int8_t
-binary_search(const char *key, u_int8_t low, u_int8_t hi)
-{
-   u_int8_t mid = (hi-low)/2 + low;
-   if (low >= hi)
-      return strncmp(key, cc_list[mid], 2);
-   if (!strncmp(key, cc_list[mid], 2))
-      return 0;
-   if (strncmp(key, cc_list[mid], 2) > 0)
-      return binary_search(key, mid+1, hi);
-   else
-      return binary_search(key, low, mid);
-}
-
 struct geoip_index {
@@ -196,3 +156,3 @@ check_geoip_cc(char *cc, u_int16_t cc_us
 
-   if (strlen(cc) != COUNTRYCODESZ) /* Country must be 2 chars long according
+   if (strlen(cc) != 2) /* Country must be 2 chars long according
                                         to the ISO3166 standard */
@@ -203,10 +163,9 @@ check_geoip_cc(char *cc, u_int16_t cc_us
    // Make sure they are..
-   for (i = 0; i < COUNTRYCODESZ; i++)
-      cc[i] = toupper(cc[i]);
+   for (i = 0; i < 2; i++)
+      if (isalnum(cc[i]) != 0)
+         cc[i] = toupper(cc[i]);
+      else
+         exit_error(PARAMETER_PROBLEM,
+               "geoip match:  invalid country code '%s'", cc);
 
-   // Verify for a valid value against the country code list.
-   if (binary_search(cc, 0, COUNTRYCOUNT-1) != 0)
-   exit_error(PARAMETER_PROBLEM,
-         "geoip match: invalid country code '%s'", cc);
- 
    /* Convert chars into a single 16 bit integer.
@@ -338,2 +297,3 @@ print(const struct ipt_ip *ip,
        printf("%s%c%c", i ? "," : "", COUNTRY(info->cc[i]));
+   printf(" ");
 }
@@ -357,3 +317,2 @@ save(const struct ipt_ip *ip,
       printf("%s%c%c", i ? "," : "", COUNTRY(info->cc[i]));
-   
    printf(" ");

--------------050204090809020602010106--
