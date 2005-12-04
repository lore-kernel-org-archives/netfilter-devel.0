From: Patrick McHardy <kaber@trash.net>
Subject: Re: SNAT from multiple interfaces with the same IP?
Date: Sun, 04 Dec 2005 17:02:09 +0100
Message-ID: <43931301.1040109@trash.net>
References: <4392E148.7010102@gmx.net> <43930BEF.9000602@trash.net>
	<20051204153729.GA5617@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20051204153729.GA5617@eychenne.org>
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

Herve Eychenne wrote:
> On Sun, Dec 04, 2005 at 04:31:59PM +0100, Patrick McHardy wrote:
> 
> 
>>I don't see why it wouldn't work, but you can't use -i in POSTROUTING
>>directly,
> 
> 
> BTW, I've always wondered why exactly...

Two reasons:

- The incoming interface is not known anymore in POST_ROUTING
- Locally generated packets don't even have an incoming interface
