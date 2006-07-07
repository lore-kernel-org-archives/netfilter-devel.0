From: "bdschuym@pandora.be" <bdschuym@telenet.be>
Subject: Re:  RFC: Disable defered bridge hooks by default
Date: Fri, 07 Jul 2006 10:17:42 +0000
Message-ID: <W673373073133751152267462@hoboe1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"bdschuym@pandora.be" <bdschuym@telenet.be>
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


>----- Oorspronkelijk bericht -----
>Van: Patrick McHardy [mailto:kaber@trash.net]
>Verzonden: vrijdag, juli 7, 2006 05:37 AM
>Aan: bdschuym@pandora.be
>CC: 'Bart De Schuymer', 'Netfilter Development Mailinglist'
>Onderwerp: Re: RFC: Disable defered bridge hooks by default
>
>bdschuym@pandora.be wrote:
>> Looks good, but please use deferred instead of defered :)
>
>This is the latest version. Fixed the crash and added a
>runtime warning to the physdev match and on-the-fly activation
>when needed, so we don't need the sysctls. Works fine in
>a few simple tests, if there are no further objections
>I'll submit this version.

I'd add something like the code below on top of your patch. That way no false warnings are given if the user specifies she only wants to look at bridged packets.

cheers,
Bart

--- net/netfilter/xt_physdev.c.old	2006-07-07 12:11:44.000000000 +0200
+++ net/netfilter/xt_physdev.c	2006-07-07 12:14:14.000000000 +0200
@@ -114,7 +114,9 @@ checkentry(const char *tablename,
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
 		return 0;
 	if (brnf_deferred_hooks == 0 && info->bitmask & XT_PHYSDEV_OP_OUT &&
-	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD))) {
+	    hook_mask & ((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD)) &&
+	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
+	       info->invert & XT_PHYSDEV_OP_BRIDGED)) {
 		printk(KERN_WARNING "physdev match: using --physdev-out in the "
 		       "OUTPUT or FORWARD chain is deprecated and breaks other "
 		       "things, it will be removed in January 2007. See "

>
