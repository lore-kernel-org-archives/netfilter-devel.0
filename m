From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix libipt_DSCP.c help message
Date: Thu, 04 Mar 2004 01:09:39 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404673C3.6050209@trash.net>
References: <997190872.20040303210409@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <997190872.20040303210409@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Maciej Soltysiak wrote:
> Hi,
> 
> this patch is pretty self-explanatory, fixes the way
> the help message is displayed.

Thanks Maciej, I've applied the patch to CVS.

Regards
Patrick


> 
> Best regards,
> Maciej
> 
> Index: libipt_DSCP.c
> ===================================================================
> RCS file: /cvspublic/iptables/extensions/libipt_DSCP.c,v
> retrieving revision 1.6
> diff -u -r1.6 libipt_DSCP.c
> --- libipt_DSCP.c       7 Aug 2002 09:55:37 -0000       1.6
> +++ libipt_DSCP.c       3 Mar 2004 20:02:22 -0000
> @@ -35,7 +35,7 @@
>  "                              or in hex (ex: 0x20)\n"
>  "  --set-dscp-class class      Set the DSCP field in packet header to the\n"
>  "                              value represented by the DiffServ class value.\n"
> -"                              This class may be EF,BE or any of the CSxx "
> +"                              This class may be EF,BE or any of the CSxx\n"
>  "                              or AFxx classes.\n"
>  "\n"
>  "                              These two options are mutually exclusive !\
> 
>  
> 
