From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: iptables as a state machine
Date: Sat, 02 Oct 2004 10:44:54 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415E6A86.6040707@drugphish.ch>
References: <20040930193955.6fa24afc.davem@davemloft.net>
	<61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: shemminger@osdl.org
In-Reply-To: <61687.63.170.215.71.1096602469.squirrel@www.osdl.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Have you looked at nf-hipac.  It works and is fast but is limited
> to 2.4 right now.  It's on my to do list...

I've started porting it as well, except a few locking issues and some 
Makefile hazzle I should be done with it. I can send it to you in private.

Having seen a lot of packet classification and matching schemes lately 
I'm a bit in favour of the IDD based approach described in [1]. The 
proof of concept implementation, which lacks a big amount of features 
still, can be found at [2]. I probably favour that since I teach Linear 
Algebra at college myself :)

An last but not least, I've written a short overview paper on the 3 
currently available "alternatives" to netfilter [3], which are "tc 
action", "nf-hipac" and "compact filter". However I unfortunately was 
required to write it in german; so it might not be of much use to a lot 
of people on this list.

[1] http://www.cs.auc.dk/~mixxel/papers/icn04.pdf
[2] http://www.cs.aau.dk/~mixxel/cf/
[3] 
http://pubwww.hsz-t.ch/~rnibali/downloads/FACHSTUDIUM/seminar/Ersatz_fuer_iptables_als_filter/iptables_ersatz.pdf

Best regards,
Roberto Nibali, ratz
-- 
echo 
'[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
