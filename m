From: Peter Christensen <pch@coolsystems.dk>
Subject: Re: Statefull SOCKS filter
Date: Fri, 10 Mar 2006 13:02:11 +0100
Message-ID: <44116AC3.1050506@coolsystems.dk>
References: <44101CA5.3070004@coolsystems.dk>
	<20060309104524.B75323@tempest.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Allen Francom <aef@prismnet.com>
In-Reply-To: <20060309104524.B75323@tempest.prismnet.com>
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

Hmm, I think I'll just do the connection state maintenance manually... 
Hopefully I will be able to do it reasonable fast.

--
Best regards

Peter Christensen

Developer
------------------
Cool Systems ApS

Tel: +45 2888 1600
  @ : pch@coolsystems.dk
www: www.coolsystems.dk


Allen Francom wrote:
> 
> 
> Once upon a time I interacted with a project called "Hogwash".
> 
> This was all layer 2 and seemed to be off to a great start.
> 
> Sounds more like what you need, "transparent".
> 
> The maintainer resigned, however the code ran, based on
> Snort and associated libraries.
> 
> With a lot of help from others, I made a binding
> for these rules into IPTables via the QUEUE target... but
> that wasn't all that clean.  Maybe skip the IPTables
> entirely, and "do like hogwash did".
> 
> 2 cents...
> 
> On Thu, 9 Mar 2006, Peter Christensen wrote:
>> I'm currently in the development of a transparent firewall bridge, 
>> whose sole purpose is to filter our everything but LAN traffic and 
>> traffic for a list of privileged servers on the Internet. Since it is 
>> meant to work on an bunch of different network configurations 
>> out-of-box, it must be able to detect and filter proxy traffic as well.
