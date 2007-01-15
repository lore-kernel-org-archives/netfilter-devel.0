From: Patrick McHardy <kaber@trash.net>
Subject: Re: What should we do with packets marked as INVALID?
Date: Mon, 15 Jan 2007 15:35:00 +0100
Message-ID: <45AB9114.2040804@trash.net>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
	<45A48260.1000400@trash.net>
	<Pine.LNX.4.64.0701151131080.13986@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0701151131080.13986@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> 
> On Wed, 10 Jan 2007, Patrick McHardy wrote:
> 
>> Krzysztof Oledzki wrote:
>>
>>> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
>>> invalid connections hang "forever") is also wrong, so maybe we should
>>> forward such packets and allow dst hosts to handle it
>>> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
>>> of the most important netfilter feature.
>>
>>
>>
>> DROP shouldn't make sessions hang (otherwise they would break with NAT
>> as well)
> 
> 
> It blocks until timeout which sometimes simply takes to long.


Not sure if I understand you correctly, but if dropping INVALID packets
makes the session hang, this would mean that valid packets are
incorrectly marked as INVALID, which would surprise me, since that
would also break with NAT (INVALID packets are not NATed) and I haven't
seen any reports of something like that.
