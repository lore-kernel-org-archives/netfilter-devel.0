From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: iptables 1.3.1 crashes on iptables-restore
Date: Thu, 31 Mar 2005 10:18:10 +0200
Message-ID: <424BB242.6070809@drugphish.ch>
References: <20050330034616.GA8639@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20050330034616.GA8639@samad.com.au>
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

> when I try to do a iptables-restore with about 800 lines I get a
> segmentation fault.
> What is the most expediant way to track this problem down ?

o Compile and link iptables with debugging info.
o Before you run the command make sure you have the core file size
   settings to unlimited (ulimit -c unlimited).
o Run your command.
o You should have a core file in your directory.
o gdb -q core /path/to/iptables-restore
o bt

Send the output to this list. Hope that is expedient enough ;).

Cheers,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
