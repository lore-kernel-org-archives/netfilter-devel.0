From: Pablo Neira <pablo@eurodev.net>
Subject: Re: New iptables structure
Date: Sun, 28 Nov 2004 21:45:49 +0100
Message-ID: <41AA38FD.5050805@eurodev.net>
References: <1101358191.5842.26.camel@localhost.localdomain>	<41A7B514.9030703@eurodev.net>
	<41A85AC4.5080006@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <41A85AC4.5080006@anduras.de>
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

Sven Anders wrote:

> Why not break compatibilty, if it hamper the development?


I don't see things that way, compatibility could be broken if all 
developers get their brains broken or become insane because they aren't 
able to workaround a problem. That didn't happen at the moment :)

> To prevent further incompatibility, you can insert some reserved 
> fields to the main
> structure...


it's not that easy, you can't always guess where they will come from. So 
we can't reserve a field in every structure.

I agree with Bart, backward compatibility is important.

--
Pablo
