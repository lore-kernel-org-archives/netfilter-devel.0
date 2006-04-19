From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Strange MASQUERADING behaviour, bug or feature?
Date: Wed, 19 Apr 2006 11:28:45 +0100
Message-ID: <444610DD.9000807@ufomechanic.net>
References: <44440CD2.6060006@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44440CD2.6060006@rtij.nl>
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

Martijn Lievaart wrote:
> Hey, that is the wrong source address! Now when I kill the null0 
> interface, suddenly the source address changes to the correct 
> (169.254.1.1) address. Also when I stop the ping and restart it, the 
> source address is correct.

Thats how NAT works.

The address mappings are setup when the conntrack is created.

You observed that this is less obviously-right for generally stateless 
streams like ping, but it is certainly consistent and makes sense, and 
is neccessary for tcp or udp connections, or they would break everytime 
other routes went up or down.

However consider the ping -I option which lets you choose which iterface 
to ping from; why should it suddenly change interface in the same ping 
just because a different route is up?

Sam
