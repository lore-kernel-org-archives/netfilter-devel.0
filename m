From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible target SBALANCE ?
Date: Wed, 30 Apr 2003 15:02:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EAFC969.6080302@tac.ch>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030428091332.GB29390@dns2.italway.it> <20030428134713.GA12364@oknodo.bof.de> <20030428150727.GA10325@dns2.italway.it> <20030429144837.GE684@naboo.intranet.astaro.de> <20030430115918.GF7343@dns2.italway.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: vecna@s0ftpj.org
In-Reply-To: <20030430115918.GF7343@dns2.italway.it>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ciao Vecna, :)

> I've felt the necessity to balance a large size of traffic, and all
> the other solutions (proposed in LVS) involves connection tracking (and 

But very simple connection tracking.

> LVS have the "bug" o "limitation" to follow session computing hash 
> with source ip and destination port only, not with between couple for 

Well, to be correct, it's a triplet of <proto, vaddr, vport> for basic hashing, 
but you can as well implement a new scheduler and register your own hashing, as 
it is done for example with the lblcr scheduler.

> trace also the replies, and this could not be fine for split traffic for
> IDS, because most needed for trace connection to read also the replis)

It's changeable, the hash could be extended if there is a real need for it. Just 
bring it on on the LVS list ;).

> but if this is not ad interesting feature for netfilter (is a firewall :)
> could be better if I ask on LVS mailing list ? 

Yes, we can discuss it there, if you prefer.

Cheers,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
