From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Proper detection of FTP-DATA
Date: Tue, 3 Jan 2006 08:08:38 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0601030808130.23554@yvahk01.tjqt.qr>
References: <C3FA62B1A90D7440B9B6C7C31895994F016C6D7A@zadbn02100.vodacom.corp>
	<Pine.LNX.4.64.0512061604120.1560@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pieter De Wit <pieter@vodacom.co.za>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0512061604120.1560@bizon.gios.gov.pl>
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


>> How would you properly match FTP-DATA connections? I have tried the
>> following and after checking the man pages, this should work ?!?
>> 
>> iptables -A INPUT -p tcp -m tcp --dport=21 # For FTP-CTRL
>> iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
>> iptables -A INPUT -m state --state RELATED -j ACCEPT

You could also use -m layer7 ;-)
http://l7-filter.sf.net/


Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
| jengelh's site, http://jengelh.hopto.org/
