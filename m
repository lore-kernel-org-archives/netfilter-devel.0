From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnfnetlink/libctnetlink  ctrace
Date: Fri, 06 Jun 2003 15:44:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EE09AAE.8040902@trash.net>
References: <20030602222644.6397.85967.Mailman@kashyyyk> <019201c32c2c$b66b89f0$010f430a@elitecore7>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
In-Reply-To: <019201c32c2c$b66b89f0$010f430a@elitecore7>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

If you like danger you could try my enhanced ctnetlink patch,
an slightly outdated version (1 1/2 weeks) is available at
trash.net/~kaber/ctnetlink. It adds notifications for all conntrack
events. This is work in progress and is not ready for serious use, but i
would of course be glad if someone else would try it. I'm syncing my
workstation and my gateway for about a week now, so it probably won't
crash your machine. If you would like to try it, i'm going to update the
patch and the userspace tool this weekend. i don't know ctrace but the
updated tool can display all events in userspace.

Bye,
Patrick

Sumit Pandya wrote:

>Hi All,
>    Refrencing from below mentioned link I try to search
>libnfnetlink/libctnetlink ctrace but couldnot locate source/binary of these
>2 packages.
>http://lists.netfilter.org/pipermail/netfilter-devel/2002-April/007515.html
>    It seems that www.linux-sna.org is closed. Do I've pointer to access
>source for those libraries and program? I think from
>http://cvs.netfilter.org/netfilter/iptables2/ libraries can be downloaded
>but what about ctrace?
>
>-- Sumit
>  
>
