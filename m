From: "Szabolcs Gyurko" <szabolcs.gyurko@tlt.hu>
Subject: Strange thing with iptables
Date: Thu, 09 Sep 2004 13:49:38 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <opsd15s018le1n2s@mail.tlt.hu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi all,


I found a strange issue with the iptables. One of my friend showed me a  
rule
which looked like:

iptables -A FORWARD -s $machine/255.255.0.255 -j ACCEPT


What I was surprised on is the netmask. Is this a feature or a bug? I mean
this is quite strange netmask for me.

Thanks for any answers,

-- 
Szabolcs Gyurko
