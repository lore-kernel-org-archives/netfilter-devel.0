From: Michael Guntsche <mike@it-loops.com>
Subject: Re: RTSP support for kernels >= 2.6.20 [patchomatic patch]
Date: Thu, 3 May 2007 19:18:37 +0200
Message-ID: <65BC6C0B-04E8-47EE-B534-2E7325044955@it-loops.com>
References: <39DCB6E6-58AA-4994-8530-16BB8FC85704@it-loops.com>	<46228193.1040707@trash.net>	<92EB4CD4-15DB-4C30-8EBD-774546F5B697@it-loops.com>	<2AFE2224-4F76-4199-9D41-F9AB48A57E9E@it-loops.com>	<46238CB4.3050504@trash.net>	<A2FA4AAE-8D76-4C0A-8583-876DB5DAA031@it-loops.com>	<E1B3F7EA-E02F-4A66-B786-F406D229E032@it-loops.com>	<46259FAD.5040401@trash.net>	<21896397-CBCD-4316-8C36-84BE051395ED@it-loops.com>	<E12A6D16-7875-4A81-B18C-5828A193E422@it-loops.com>	<72A36DB9-BC11-48B7-B450-96F701631709@it-loops.com>	<462C9BAE.8010001@trash.net>
	<68F6B0B3-7A63-4933-86B0-50E73E03B227@it-loops.com>
	<4639C0C3.10200@trash.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4639C0C3.10200@trash.net>
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

Hi Patrick,
	
On May 3, 2007, at 13:00, Patrick McHardy wrote:

> If you'd add it in pom external repository format I could add it to
> the pomng sources.list.
>

I prepared a repository but I am not sure how to package it. Should I  
add it to the existing rtsp-conntrack module, which does not work  
right now, since --download blames that rtsp-conntrack is not  
external, or should I leave the old module as is and add a new one  
called nf-rtsp-conntrack wich requires a kernel >= 2.6.20?

Michael
