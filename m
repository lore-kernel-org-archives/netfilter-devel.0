From: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
Subject: Re: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Sun, 14 Dec 2003 00:35:38 +0100
Sender: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Message-ID: <200312140035.38759.bdschuym@pandora.be>
References: <Pine.LNX.4.44.0312121948321.8670-200000@sorbus2.navaho>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
To: Steve Hill <steve-5X2ZMFkmWHHQXOPxS62xeg@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
	<netfilter-devel-wool9L35kiczKOhml7GhPkB+6BGkLq7r@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44.0312121948321.8670-200000-P6xViTKO+D9l6dsDrSIFUQ@public.gmane.org>
Content-Disposition: inline
Errors-To: ebtables-devel-admin-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5ji9XKYC2TYK4Io4DoRGLOrNAH6kLmebB@public.gmane.org>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5lLLH9aP38KF1pqr+6INuaA@public.gmane.org>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5utDmRdBvX5/5R9m/fhtKvoLKtGCp0j7rLg@public.gmane.org>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=ebtables-devel>
List-Id: netfilter-devel.vger.kernel.org

On Friday 12 December 2003 20:55, Steve Hill wrote:
> Sorry for the cross-post - I thought this would be of interest to all the
> lists and also wasn't sure where the best people to help hang out.

The right mailing list for this is netdev-VZNHf3L845rowKkBSvOlow@public.gmane.org

> With both conntrack and bridging turned on in the 2.6.0test11 kernel,
> sending fragmented packets over the bridge reveals a memory leak
> (specifically, forwarding packets from any interface to a bridge).  The
> memory that is leaking seems to be being allocated on line 299 on
> net/bridge/br_netfilter.c:
>
>         if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
>                 return NF_DROP;

Thanks for the good diagnose.

> Only the first fragment gets freed later on.
>
> The patch attached fixes the problem by freeing nf_bridge when the
> packets are defragmented, however I am sure this is not the right place
> to do this.  Where would the skb's for the fragments usually get freed?

I believe they are freed in skbuff.c::skb_release_data().

I think the place where you've put the fix doesn't cover all cases. If 
ip_frag_destroy() is called, there will still be a memory leak. So I think 
the right place for this is in skb_release_data. But consulting with the 
netdev list seems appropriate :)

You can change
+		if (fp->nf_bridge) {
+			nf_bridge_put(fp->nf_bridge);
+			fp->nf_bridge = NULL;
+		};
into
+		nf_bridge_put(fp->nf_bridge);

cheers,
Bart



-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
