From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: Re: Adding packet metadata
Date: Wed, 24 Mar 2004 09:18:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4061446C.7050502@yahoo.it>
References: <Pine.LNX.4.44.0403240852150.22258-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Scott MacKay <scottmackay@yahoo.com>,
   Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403240852150.22258-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Wed, 24 Mar 2004, Mike-Ro-Chanel wrote:
> 
> 
>>An interesting question about MARK field in SKB structure is: Can I use 
>>all 32-bit of "nfmark" for adding metadata?
> 
> 
> Yes.
> 
> 
>>Iptables front-end (from command line) seems to take mark value as a
>>8-bit number.
> 
> 
> What makes you think so?

Now I understand, it is my error on iptables usage.

> There is a slight signed bug in the string_to_number function which 
> prevents the use of the 2^31 bit, easily fixed by changing it to use 
> unsigned.
> 
Ok, thanks for the tip!

		Mike-Ro-Chanel
