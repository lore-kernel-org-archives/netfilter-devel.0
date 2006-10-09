From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: Compiling 1.3.6
Date: Mon, 09 Oct 2006 18:10:56 +0200
Message-ID: <BAY103-F3071C68178C779A4BD21EEB2160@phx.gbl>
References: <452A72A9.4060800@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	mysql.jorge@decimal.pt, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <452A72A9.4060800@trash.net>
To: kaber@trash.net
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

Patrick McHardy wrote:

>Marco Berizzi wrote:
> > Pablo Neira Ayuso wrote:
> >
> >> Pablo Neira Ayuso wrote:
> >>
> >>> Patrick McHardy wrote:
> >>>
> >>>> Pablo Neira Ayuso wrote:
> >>>>
> >>>>> min_ip and max_ip type has been changed from u_int32_t to __be32
> >>>>> that is
> >>>>> not defined in userspace, this breaks iptables compilation.
> >
> >
> > I'm able to compile iptables 1.3.6 with 2.6.18 kernel
> > headers without any errors.
> > However iptables 1.3.6 + linux 2.6.19-rc1 kernel
> > headers give me this error:
>
>Does the patch I just sent fix it?

Yes, now I'm able to compile iptables 1.3.6 with 2.6.19-rc1
kernel headers with your patch:

Index: include/iptables_common.h
===================================================================
--- include/iptables_common.h   (Revision 6660)
+++ include/iptables_common.h   (Arbeitskopie)
@@ -42,4 +42,9 @@
   extern void init_extensions(void);
#endif

+#define __be32 u_int32_t
+#define __le32 u_int32_t
+#define __be16 u_int16_t
+#define __le16 u_int16_t
+
#endif /*_IPTABLES_COMMON_H*/
