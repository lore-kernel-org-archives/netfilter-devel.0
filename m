From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] compilation error + kernel panic sip-conntrack-nat
Date: Wed, 29 Mar 2006 11:07:40 +0200
Message-ID: <442A4E5C.4090702@trash.net>
References: <20060327135637.GA19422@runtux.com> <442A4826.3060908@trash.net>
	<20060329090354.GA23408@runtux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ralf Schlatterbeck <rsc@runtux.com>
In-Reply-To: <20060329090354.GA23408@runtux.com>
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

Ralf Schlatterbeck wrote:
> On Wed, Mar 29, 2006 at 10:41:10AM +0200, Patrick McHardy wrote:
> 
>>Ralf Schlatterbeck wrote:
>>
>>>Note: The FAQ-Entry about SIP 
>>>http://www.netfilter.org/documentation/FAQ/netfilter-faq-1.html#ss1.8
>>>should be updated to point to sip-conntrack-nat, see
>>>http://www.iptel.org/sipalg/
>>>The conntrack module would surely get more testing if it is mentioned in
>>>the FAQ :-)
>>
>>Feel free to send a patch :)
> 
> 
> Can you tell me where I should look for the sources? Is this directly
> maintained in HTML? For the other documents I suppose the SGML version
> is the original -- but for the FAQ there isn't an SGML document.

I only I knew .. The FAQ stuff is under output/ in the SVN repository,
so I suppose there must be an input somewhere :)
