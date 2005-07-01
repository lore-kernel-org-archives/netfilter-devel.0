From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Fri, 01 Jul 2005 09:08:24 +0200
Message-ID: <42C4EBE8.7050804@drugphish.ch>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rv@eychenne.org
In-Reply-To: <20050629160923.GF3331@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> I remember saying here that it would be cool to have the log prefix length
> tunable at kernel LOG module insertion, have it exported (read-only) to some
> /proc entry, and have userspace (iptables, or any other upper-level
> application) rely on the real-time extracted value.
> What do you think?

Could work, although I'm not sure why you'd want to change the prefix 
lenght that often, however flexibility is nice.

Another issue I see is that iptables, when sending the data from user to 
kernel space, must be made aware of setting the correct target{info}size 
in case the ipt_*LOG module is not loaded yet. Parsing proc-fs would be 
useless. This opens a possible "DoS", which can be addressed by having a 
max log prefix length accepted as being passed to the lkm.

Was there any consensus regarding this feature among the core netfilter 
developers or has anyone posted a POC patch? Granted, there are a 
billion more important things to address, but still ... ;)

Regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
