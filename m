From: Amin Azez <azez@ufomechanic.net>
Subject: Re: output device
Date: Fri, 03 Mar 2006 13:33:40 +0000
Message-ID: <440845B4.3000208@ufomechanic.net>
References: <200603030944.11858.kgy@deverto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200603030944.11858.kgy@deverto.com>
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

Kovesdi Gyorgy wrote:
> Hi,
> 
> I would like to set the output device in a rule (it is needed due to 
> overlapping addresses). AFAIK, it cannot be done directly in a rule (if I am 
> wrong, plese tell me immediately). I tried using iptables2 for this: it is 
> working, but significantly slower (3...5 times) than a single routing rule.
> I think it should be added to the netfilter and conntrack system (keeping its 
> speed), but I don't know how much work such an expansion costs, and I am not 
> familiar enough in developing this field.
> Do you have any idea?

why can't you use ipt_route ?

Sam
