From: "John Lumby" <johnlumby@hotmail.com>
Subject: Re: Removal of ROUTE target - what now?
Date: Mon, 06 Aug 2007 13:50:33 -0400
Message-ID: <BAY137-F2180377B29674B0F4EA7EBA3E50@phx.gbl>
References: <Pine.LNX.4.64.0708061011330.1735@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org, david@davidcoulson.net
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708061011330.1735@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt  wrote:
>On Aug 5 2007 21:27, John Lumby wrote:
> > Well, i tested with and without - seems to work in each case.
>>  [...]
> > Don't know if that was a valid test.
>
>Does it still work when the following three are set to 1?
>	/proc/sys/net/ipv4/conf/all/rp_filter
>	/proc/sys/net/ipv4/conf/ppp0/rp_filter
>	/proc/sys/net/ipv4/conf/ppp1/rp_filter
>
Yes

The initial settings of the ppp[x]/rp_filter were both 1 and the setting of 
the all/rp_filter was 0.  I set the all rp_filter to 1 AFTER bringing up my 
ppp1 interface (but of course before trying an SMTP session) if that  makes 
any difference.

I'm running kernel 2.6.20.9

John

_________________________________________________________________
Show Your Messenger Buddies How You Really Feel 
http://www.freemessengeremoticons.ca/?icid=EMENCA122
