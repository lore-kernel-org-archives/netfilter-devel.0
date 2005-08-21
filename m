From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: Question, my modifed -j LOG
Date: Sun, 21 Aug 2005 02:27:03 +0200
Message-ID: <4307CA57.9090600@gmx.net>
References: <20050820172824.GE5638@aaricia.csbnet.se>	<Pine.LNX.4.61.0508202154050.18226@yvahk01.tjqt.qr>	<20050820202552.GF5638@aaricia.csbnet.se>
	<Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0508210021050.22186@yvahk01.tjqt.qr>
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

Jan Engelhardt schrieb:
>>> From a FW designer's POV, I would say you have got too much rules.
>> 
>>Its a _very_ large router infront of a student network. It house sover 2000
>>computers behind it and has a traffic amount between 50Mbit and 400Mbit
>>(night and day) for each of the 2 large main interface. Now the machine has
>>and additionally 30 interfaces. Most of them virtual VLAN interfaces. Point
>>is, this is a _very large_ routing machine. The machines work can't be done
>>in 63 rules. No way. Not with all the functions i have. The large amount of
> 
> The question is: how different do all these 2000+ hosts need to be classified?
> I can't think of anything but to let everything through with possibly 
  ^^^^^^^^^^^^^^^^^^^^^^^^^
> exceptions like SMTP and HTTP (going over proxies there).

You haven't yet managed such a big student network, right? Especially if
the same IP range also includes non-students living in the same buildings,
being able to freely roam and still get access to their own services and
having different rules, shaping based on traffic history, IP, port and
building they're sitting in, DoS protection for the hosts behind, limits
on filesharing, redirection of a few services, exceptions to all the
rules above because of people being "important", load distribution etc.
Even with a tree-based approach using goto, ipsets and other useful tools
to shorten chain length, you may end up with >200 iptables rules in your
set plus >100 ebtables rules plus >100 tc rules and still have some work
to do. And in such a scenario most of the logic is in userspace to keep
the ruleset in the kernel short.

Some things in reality can be simplified. Some others are already as
simple as possible.

Please don't criticize other people before understanding their problems.

And please don't strip the author of quoted text.

Regards,
Carl-Daniel
