From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] flow statistic match
Date: Tue, 01 Oct 2002 10:53:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3D99629F.1020204@tac.ch>
References: <Pine.LNX.4.44L.0209172337160.10390-102000@hunger.screamingdaemon.com> <20020918215958.GE10465@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jay Schulist <jschlst@linux-sna.org>, Harald Welte
 <laforge@gnumonks.org>,
   netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi.

> As a proposal out of the blue, what about calling it "ctvolume", instead?

Why :)

> Would it be possible, in the near future, to use a "ctnetlink" interface
> to get at the final counters when a conntrack is destroyed? :-)

Roman has done something like that already for our company, the patch (not the 
final version, but enough to have a glance at it) can be fetched at:

http://www.drugphish.ch/patches/roman/slog-kernel-2.4.18.diff

Cheers,
Roberto Nibali, ratz

-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
