From: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
Subject: Re: [PATCH resend 1/2] Adds ebt_nflog watcher to
	kernel.
Date: Tue, 26 Feb 2008 00:24:01 +0100
Message-ID: <1203981841.2959.6.camel@localhost.localdomain>
References: <20080205185521.051763000@andrew.endian.com>
	<20080205185617.732255000@andrew.endian.com>
	<47BD86EF.7060809@trash.net> <47C34933.8000301@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <47C34933.8000301-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Op di, 26-02-2008 te 00:03 +0100, schreef Peter Warasin:
> Hi
> 
> Patrick McHardy wrote:
> > Peter Warasin wrote:
> >  > This patch adds the ebtables nflog watcher to the
> >  > kernel
> > This seems mostly fine to me. A few minor comments:
> 
> > If you'll resend the patch based on net-2.6.26 I'll queue it
> > if Bart has no objections.
> 
> I re-based on net-2.6.26 and changed what you mentioned.
> Patch is attached

It looks fine, I'm just wondering what the flags and the pad in struct
ebt_nflog_info are for...

cheers,
Bart



-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
