From: Robbie Dinn <robbie@microbus.com>
Subject: Re: how to install time patch
Date: Thu, 17 Nov 2005 12:12:33 +0000
Message-ID: <437C73B1.20805@microbus.com>
References: <20051117110729.16390.qmail@web53604.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: manish popli <popli_manish77@yahoo.com>
In-Reply-To: <20051117110729.16390.qmail@web53604.mail.yahoo.com>
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

manish popli wrote:
> I am fail to install time patch for iptables..
> i have visited at 
> http://www.lowth.com/howto/add-iptables-modules.php
> 
> but i m not able to doit successful..can any one guide
> me how to install "libipt_time.so" under Enterprise
> linux AS-3 (Linux version 2.4.21-4.ELsmp)..

I can not help you with the time patch, but maybe you
could try something else instead to avoid having to patch
your kernel. How about having two or more sets of firewall
rules and using cron to load the appropriate firewall rules
at the time of day you want the rules to change?
