From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] tcp window tracking patch with SACK support
Date: Mon, 18 Nov 2002 10:48:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DD8B788.2090109@tac.ch>
References: <20021017163909.GO344@pc.ilinx> <Pine.LNX.4.33.0210181255170.10340-100000@blackhole.kfki.hu> <20021018144818.GJ2408@naboo.club.berlin.ccc.de> <3DC8FDF5.7050906@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org,
   netfilter@interlinx.bc.ca
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Sucess report:

> I will now (after I have more or less proven that without this SACK 
> patch we're running into problems too) patch my kernel and try it again. 

Unpatched kernel              : A lot of DROPs
Patched kernel (SACK support) : _No_ DROPs which are illicit drops.

I've run the new packet filter for 16 hours and I am now evaluating 1.2Gbytes of 
logfiles. So far it looks good. It has cured the obvious problems I've had with 
the initial tcp window tracking patch.

I see now however, that there is still one open report from Brian.

Thanks,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
