From: Henrik Nordstrom <hno@marasystems.com>
Subject: RE: information
Date: Sat, 3 Jul 2004 10:56:34 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407031050250.29271-100000@filer.marasystems.com>
References: <200407030819.i638JSMX024604@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'Babar Qaisrani'" <baqb03@student.bth.se>,
   "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200407030819.i638JSMX024604@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 3 Jul 2004, Muhammad R. Sami wrote:

> Yes, I mean to say the verdict. Now I am a bit confused. Is not the verdict
> enough to tell the kernel what to do with the packets? If yes, then it does
> not work with me more than once. 

The verdict tells what to do with the packet in this hook 
(PREROUTING/FORWARD/POSTROUTING etc). Only if the verdirct is NF_ACCEPT is 
the packet accepted by this hook.

Why it only works "once" for you I do not know. Maybe if you describe in 
full details what you mean by "once" we can find some hint to what is 
going wrong.

It is only that your talk about nfmark made me a little confused. nfmark
is not related to the verdict. See the MARK target and/or linux advaced
routing howto for more info on nfmark in case you want to learn more what
the nfmark is and how it may be used. But it is not related to your 
problem.

Regards
Henrik
