From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: remove connections notification by conntrack?
Date: Sun, 15 Oct 2006 18:11:02 +0200
Message-ID: <45325D96.9090004@netfilter.org>
References: <200609221359.22676.thezema@gmail.com>
	<200609241151.31689.thezema@gmail.com>
	<4516A577.7080802@netfilter.org>
	<200610151501.28715.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Mader <thezema@gmail.com>
In-Reply-To: <200610151501.28715.thezema@gmail.com>
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

Thomas Mader wrote:
> we figured out what the problem was some time ago, sorry for the delay. We 
> forgot to put it back as you said earlier.
> We want to publish our code soon here on the mailinglist to finish this topic 
> and to help others with our code as an example but we don't find out how to 
> send ICMP packets from kernelspace.
> Maybe you or somebody else could point us to some code example or something so 
> we can implement it? We searched the kernel code and the net for examples but 
> we wasn't successful at finding working examples.

Is send_icmp what you look for? See ipt_REJECT.c, I think that it can
serve as example.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
