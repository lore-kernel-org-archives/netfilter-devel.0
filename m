From: Pablo Neira <pablo@eurodev.net>
Subject: Re: CVS problems since July 29, 2005.
Date: Tue, 02 Aug 2005 15:10:39 +0200
Message-ID: <42EF70CF.7000904@eurodev.net>
References: <1122911330.42ee4462a5b53@mail.jfarjona.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Juan F. Arjona" <jfarjona@jfarjona.com>
In-Reply-To: <1122911330.42ee4462a5b53@mail.jfarjona.com>
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

Juan F. Arjona wrote:
> Hello guys:
> 
> Sorry to use this list to report this issue, but the CVS server seems to be down
> (or firewalled):
> 
> cvs -d :pserver:cvs@pserver.netfilter.org:/cvspublic login
> Logging in to :pserver:cvs@pserver.netfilter.org:2401/cvspublic
> CVS password:
> cvs [login aborted]: connect to pserver.netfilter.org(213.95.27.115):2401
> failed: Connection refused
> 
> Could you please let me know if I am accessing the wrong box?

netfilter doesn't use CVS anymore, please see:

https://lists.netfilter.org/pipermail/netfilter-announce/2004/000063.html

--
Pablo
