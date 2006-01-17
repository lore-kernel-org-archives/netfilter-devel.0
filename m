From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: conntrack for multiple interfaces
Date: Tue, 17 Jan 2006 09:55:28 +0100
Message-ID: <1137488128.5084.5.camel@bzorp.balabit>
References: <200601161355.22867.kgy@deverto.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Kovesdi Gyorgy <kgy@deverto.com>
In-Reply-To: <200601161355.22867.kgy@deverto.com>
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

On Mon, 2006-01-16 at 13:55 +0100, Kovesdi Gyorgy wrote:
> Hi,
> 
> Is there any special mailing list for libnetfiler_conntrack?

I don't know of any, I think you can post here.

> 
> My machine has assigned the same IP range for multiple interfaces. Is the 
> conntrack able to handle this?

Conntrack is interface independent, however it does not handle when
tuples collide, it assumes they are part of the same connection. (ie. it
does not work, unless your IP space is actually divided between
interfaces and connections never collide)

-- 
Bazsi
