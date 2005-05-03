From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Connection ID in conntrack and libctnetlink / Max connections
 showed by conntrack
Date: Tue, 03 May 2005 02:01:20 +0200
Message-ID: <4276BF50.6020101@eurodev.net>
References: <1114945720.22582.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roman Ammann <rammann@ita.hsr.ch>
In-Reply-To: <1114945720.22582.26.camel@localhost.localdomain>
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

Hi,

Roman Ammann wrote:
> Problems:
> 
> a) I can't drop a connections because I have to pass the connections ID
> to the programm conntrack (conntrack -D conntrack -i <id>) and conntrack
> doesn't listen dem (conntrack -L conntrack).
> 
> b) I used conntrack (conntrack -L conntrack) to list my current
> connections. But conntrack list just 16 connections. But if I
> use /proc/net/ip_conntrack is see 31 connections. 

The problems that you've reported are fixed in SVN. Please upgrade.

--
Pablo
