From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Thu, 1 Jul 2004 09:12:04 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040701161204.GA32568@linuxace.com>
References: <20040615044723.GA16891@linuxace.com> <40CE95DE.9090703@trash.net> <20040617155946.GA28564@linuxace.com> <40D1C4BF.8070605@trash.net> <20040618171214.GA750@linuxace.com> <40D62FDB.8090904@trash.net> <20040629175426.GA25242@linuxace.com> <40E1AE4D.7040306@trash.net> <20040629200944.GA25735@linuxace.com> <40E28CFA.30206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <40E28CFA.30206@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jun 30, 2004 at 11:50:50AM +0200, Patrick McHardy wrote:
> Could be, but I doubt it. Could you try without CONFIG_NETFILTER_DEBUG
> once more ?

Interestingly, when it crashed that one time it was in tcp_find_option,
and I had a uniprocessor box hang in tcp_find_option yesterday also.  It
looks like I'm hitting the infinite loop discussed here:

http://www.netfilter.org/security/2004-06-30-2.6-tcpoption.html

since I have 2 tcp-option rules:

$IPT -A badtcp -p tcp --tcp-option 64 -j logdrop
$IPT -A badtcp -p tcp --tcp-option 128 -j logdrop

So I'll apply that patch along with your FTP locking patch and see how
it works out.

Phil
