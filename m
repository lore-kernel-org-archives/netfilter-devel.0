From: "Zachary Link" <zack@the-links.net>
Subject: Re: src/dest wilcard matching
Date: Tue, 21 Sep 2004 09:12:15 -0400 (EDT)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <65001.139.76.128.1.1095772335.squirrel@www.the-links.net>
References: <54512.139.76.128.1.1095257166.squirrel@www.the-links.net>
	<200409161256.23156.apw@shadowen.org>
Reply-To: zack@the-links.net
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200409161256.23156.apw@shadowen.org>
To: "Andy Whitcroft" <apw@shadowen.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

<quote who="Andy Whitcroft">
<snip>
> iptables -A FORWARD -d 10.0.0.1/255.0.0.255 -j ACCEPT
</snip>

That is cool, I hadn't thought of masking like that.  While it might not
be the perfect solution for me, I can probably make this work pretty well.

Thanks to all who responded, much appreciated.

Zack
