From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: [PATCH] combine iptables, iptables-save and iptables-restore
 for	size reduction
Date: Tue, 22 Jun 2004 07:39:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D7C624.80606@drugphish.ch>
References: <1087852753.2962.27.camel@x1722074250.edup.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bastiaan Bakker <bastiaan.bakker@lifeline.nl>
In-Reply-To: <1087852753.2962.27.camel@x1722074250.edup.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> The iptables, iptables-save and iptables-restore binaries contain a
> relatively large amount of identical code. In most cases this doesn't
> matter, but on embedded platforms 100KB can make a difference.
> Attached is a small patch against iptables 1.2.10 which enables building
> iptables, iptables-save and iptables-restore into 1 multi-purpose
> binary. In BusyBoxy style it selects the correct command based on
> argv[0].

Wonderful, thanks for doing it. Hope it gets applied.

Best regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
