From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: RE: Extracting port numbers
Date: Thu, 4 May 2006 13:05:46 +0800
Message-ID: <042001c66f38$6b5d82e0$aa0ba8c0@l7.com.tw>
References: <ba7fdfc10605021325o39c09204r798e385b75e6b5bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Srinivas Krishnan'" <shrin_krishnan@yahoo.com>,
	<netfilter-devel@lists.netfilter.org>
In-Reply-To: <ba7fdfc10605021325o39c09204r798e385b75e6b5bf@mail.gmail.com>
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

>
>Hi,
>
>I was trying to extract tcp port numbers from sk_buff, going 
>through netfilter code, there seem multiple ways of doing it. 
>I was wondering if there is one standard way to do it which is 
>generic enough to fit any situation.
>
>For seem reason the
>struct tcphrd *tcp = (struct tcphrd *)(skb->data + 
>(skb->nh.iph->ihl*4));
>
>dest_port = tcp->dest;
>
>does not work and extracts wrong port numbers.
>

It seems ok. Do you miss to use the ntohs function to conver to the
correct form?

Vincent
