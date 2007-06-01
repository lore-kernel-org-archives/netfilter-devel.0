From: Patrick McHardy <kaber@trash.net>
Subject: Re: change in behavior of OUTPUT chain rule in 2.6.19
Date: Fri, 01 Jun 2007 17:41:31 +0200
Message-ID: <46603E2B.8080503@trash.net>
References: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Accetta <maccetta@laurelnetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <13313.1180642185@mdt.dhcp.pit.laurelnetworks.com>
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

Mike Accetta wrote:
> Jan Engelhardt writes:
> 
>>On Dec 14 2006 13:30, Mike Accetta wrote:
>>
>>>Between 2.6.18 and 2.6.19 (and 2.6.19.1) we've observed that a reject rule 
>>
>>on
>>
>>>the OUTPUT chain no longer causes a connection attempt to abort immediately
>>>with "Connection refused".  As a specific example, this rule
>>>
>>>iptables -A  OUTPUT -p tcp --destination-port 23 \
>>>--destination 10.0.20.1  -j REJECT --reject-with tcp-reset
>>
>>I cannot reproduce this with 2.6.20.2. Have you tried any newer kernel?
> 
> 
> This was filed as Bugzilla #7716 and fixed by Patrick McHardy in 2.6.20.


The patch was also sent to -stable, I think its in 2.6.19.3.
