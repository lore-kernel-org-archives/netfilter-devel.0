From: Munehisa Kamata <kamatam@amazon.com>
Subject: Re: [PATCH -stable,4.x.y] netfilter: nf_nat_redirect: add missing
 NULL pointer check
Date: Mon, 18 Jan 2016 11:27:13 -0800
Message-ID: <569D3C91.7040409@amazon.com>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <20151106170858.GB24185@kroah.com> <20151106172610.GA1357@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <stable@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Greg KH <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151106172610.GA1357@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Greg,

This commit is already in Linus's tree. Could you please pick this up for 4.1.y?

Regards,
Munehisa

On 11/6/2015 9:26 AM, Pablo Neira Ayuso wrote:
> On Fri, Nov 06, 2015 at 09:08:58AM -0800, Greg KH wrote:
>> On Fri, Nov 06, 2015 at 01:44:43PM +0100, Pablo Neira Ayuso wrote:
>>> From: Munehisa Kamata <kamatam@amazon.com>
>>>
>>> [ upstream commit 94f9cd81436c85d8c3a318ba92e236ede73752fc ]
>>
>> This isn't a valid git commit id in Linus's tree :(
> 
> This is David's tree already:
> 
> http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=94f9cd81436c85d8c3a318ba92e236ede73752fc
> 
> So this should hit Linus tree soon.
> 
