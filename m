From: Roberto Nibali <ratz@tac.ch>
Subject: [SOLVED] Re: 2.4.22-pre9 and pending patches issues
Date: Wed, 30 Jul 2003 11:21:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F278DFC.1080706@tac.ch>
References: <3F27723B.7040502@tac.ch> <Pine.LNX.4.52.0307300933570.27087@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

> I'll look into it tonight.

I've solved it myself by engaging my brain. I did a very stupid mistake: I cat'd 
all pending patches into one patch and tried to apply this one, instead of 
applying every single one. Now it works with some minor/major offsets.

I can also successfully apply the tcp-window-tracking patch on top of the 
pending patches. I apologize to you for the waste of time and to the list for 
the waste of electrons.

You still might to rediff the pending patches ;).

Best regards and a quiet evening,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
