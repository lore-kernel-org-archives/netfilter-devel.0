From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] runme patch for 2.5
Date: 12 Nov 2002 20:50:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1037130643.4402.45.camel@tux>
References: <Pine.LNX.4.44.0210291133530.9352-100000@sparrow>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
In-Reply-To: <Pine.LNX.4.44.0210291133530.9352-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2002-10-29 at 17:37, William Stearns wrote:

> 	Harald, do you have any concerns about the patch?  (Not resent in 
> this mail, though I'd be happy to).

I don't know if Harald told you but he applied your patch and I finally
got around to building a new kernel here. I found a small problem with
your patch and I corrected the runme in cvs.

my changes to runme:
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/patch-o-matic/runme?r1=1.29&r2=1.30&f=u

Harald, I know I wasn't supposed to touch runme in cvs but I couldn't
help myself when I found the problem :)
The same problem exists in patch-o-matic_2.5/runme which I don't have
permission to alter, same patch works there as they were identical.

cd patch-o-matic_2.5 ; wget -qO - "$url" | patch -p2


I havn't looked at the new configurationsystem in 2.5, will that make
our stuff in patch-o-matic incompatible?
 
-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
