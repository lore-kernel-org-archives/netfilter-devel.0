From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: New logging module
Date: Sun, 07 Sep 2003 21:13:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5B833C.601@drugphish.ch>
References: <Pine.LNX.4.44.0309060259570.4937-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0309060259570.4937-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Henrik,

> 3 looks very intersting and is something which we have been thinking we
> need for a long time to implement meaningful accounting in a
> iptables+conntrack+NAT based firewall.
> 
> What we have considered to log from conntrack is maybe a little more than
> described above:
> 
> 1. Start of session
> 
> 2. Periodically while the conntrack session is active (preferably 
> by a configurable interval)
> 
> 3. End of session

SLOG was designed to handle 1 and 3 but is easily extensible with 2, 
provided someone finishes the work.

> with byte and packet counters in both directions.
> 
> '2' to be able to account "last 5 minutes of traffic" even if there is 
> long-running sessions, but not too often. Once per accounting interval 
> used is required, more often is overhead, less gives less accuracy than 
> desired for the accounting.
> Do you know if anyone else is attempting to do this?  If not we might give
> it a stab shortly..

As Harald mentioned, there is the SLOG target patch which we started 
once in our company based on a student's semester work. You can find the 
current drop here:

http://www.drugphish.ch/patches/ratz/netfilter/

I have not touched much of it since its first write and it currently 
crashes the kernel. Another problem is that I simply didn't have the 
time to track {ct,nf}-netlink changes. So the status of the patch is the 
following:

o based on 2.4.18, which means that it will _not_ work and most
   definitely not even apply to recent kernels anymore.
o The development version (the one with the correct implementation of 1
   and 3) crashes upon reception of the first packet for SLOG which is
   most probably a missing initialisation in the timer handling.
o the user-space patch should be pretty easy to forward port.
o I had 4 people using the non-development version and giving me
   feedback but I haven't heard back from them since.

Please contact me privately if you're interested in working on SLOG.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
