From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: conntrack for multiple interfaces
Date: Tue, 17 Jan 2006 12:48:13 +0100
Message-ID: <43CCD97D.80800@gmx.net>
References: <200601161355.22867.kgy@deverto.com>
	<1137488128.5084.5.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Kovesdi Gyorgy <kgy@deverto.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <1137488128.5084.5.camel@bzorp.balabit>
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

Balazs Scheidler schrieb:
> On Mon, 2006-01-16 at 13:55 +0100, Kovesdi Gyorgy wrote:
> 
>>My machine has assigned the same IP range for multiple interfaces. Is the 
>>conntrack able to handle this?
> 
> Conntrack is interface independent, however it does not handle when
> tuples collide, it assumes they are part of the same connection. (ie. it
> does not work, unless your IP space is actually divided between
> interfaces and connections never collide)

That's unfortunate. IIRC someone posted a patch to netfilter-devel half
a year ago (sorry, no exact date) to address that issue. Was there some
reason not to include it back then?
The only problem with that patch I can think of right now would be load
balancing over multiple links.


Regards,
Carl-Daniel
