From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: new match extension to implement port knocking in one
Date: Tue, 17 Oct 2006 03:23:43 +0200
Message-ID: <4534309F.8000200@netfilter.org>
References: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "J. Federico Hernandez" <fede.hernandez@gmail.com>
In-Reply-To: <c0db55360610160810s164cbf26lf58390b818cdf443@mail.gmail.com>
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

J. Federico Hernandez wrote:
>> On Oct 14, 2006, Michael Rash wrote:
>>
>> Well, I agree that having an implementation that builds some port
>> knocking capabilities directly into iptables is a good thing for the
>> reasons you mention.  However, I would say that there are some design
>> considerations that warrant userspace implementations as well.  Users
>> should be able to select the system that offers the best security
>> properties, and putting both the authentication and authorization
>> verification code in the kernel is not always going to meet everyone's
>> needs.
> 
> We think that recognizing a port knocking sequence is an issue of the
> firewall (netfilter in this case), and if you want to open a port
> after a correct seq, the firewall is also the place. But sometimes you
> want to trigger a more complex action from this correct knock seq
> (e.g. start a webserver), so we allow to send a netlink msg from
> kernel to a listening userspace application that could decide what
> action to take. This userspace app is not scanning logs nor sniffing
> your iface, it's just waiting to receive an important message from
> kernel.

Perhaps I'm just influenced by my first impression but I think that this
thing should be in userspace. We are providing the appropiate netfilter
netlink subsystems (nfqueue, nflog...) to implement this as a userland
daemon.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
