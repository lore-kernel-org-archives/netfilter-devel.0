From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH IP6TABLES]: don't allow to specify protocol of IPv6
 extension header
Date: Wed, 29 Mar 2006 11:09:52 +0200
Message-ID: <442A4EE0.6060806@trash.net>
References: <200603290659.k2T6xDJh017360@toshiba.co.jp>	<442A4127.70908@trash.net>
	<200603290834.k2T8Y8q5024524@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200603290834.k2T8Y8q5024524@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Wed, 29 Mar 2006 10:11:19 +0200
> 
> 
>>Yasuyuki KOZAKAI wrote:
>>
>>>Hi,
>>>
>>>Sometimes I hear that people do 'ip6tables -p ah ...' which never matches
>>>any packet. IPv6 extension headers except of ESP are skipped and invalid
>>>as argument of '-p'. Then I propose that ip6tables exits with error in such
>>>case.
>>
>>How about a warning for some time first? If people use iptables-restore
>>this could break their entire ruleset ..
> 
> 
> OK, then please ignore previous 'fixed patch' and apply this. Sorry for mess.

Done, thanks. Is your SVN access not working?
