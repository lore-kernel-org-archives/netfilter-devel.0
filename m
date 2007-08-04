From: David Coulson <david@davidcoulson.net>
Subject: Re: Removal of ROUTE target - what now?
Date: Sat, 04 Aug 2007 09:47:17 -0400
Message-ID: <46B48365.6060502@davidcoulson.net>
References: <BAY137-F26BDAB7CC7FE589BFB7F4DA3EB0@phx.gbl>	<46B3D859.8090906@davidcoulson.net>
	<Pine.LNX.4.64.0708041040030.11760@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, John Lumby <johnlumby@hotmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708041040030.11760@fbirervta.pbzchgretzou.qr>
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

It has been a while since I was running a configuration like that, 
however I believe that the kernel does not walk every routing table on 
the system in order to establish RPF state.

Might be wrong though - Been a few years.

Jan Engelhardt wrote:
> Since the routing layer now knows about a.b.c.d->p.q.r.s (it does not
> when you use ipt_ROUTE), things could work even if RPF are on.
> Of course that I what I believe or what I believe should be happening;
> if it is not, feel free to correct me :)
>   
