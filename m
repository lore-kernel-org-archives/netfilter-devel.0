From: Martijn Lievaart <m@rtij.nl>
Subject: Re: Writing Queue-Modul in Pascal
Date: Sun, 20 Nov 2005 14:02:09 +0100
Message-ID: <438073D1.2040509@rtij.nl>
References: <437FAF08.7050401@hin.de> <43803B64.1080308@rtij.nl>
	<43806B00.5070707@hin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sven@hin.de
In-Reply-To: <43806B00.5070707@hin.de>
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

sven@hin.de wrote:

> Martijn Lievaart schrieb:
>
>>
>> The examples are in C, not C++. Using Pascal should be relatively 
>> straightforward if you can somehow translate the C headerfiles.
>>
>> M$
>
>
> I thought, m is an object (m->packet_id).
> I take a look in these headerfiles.
>
Ah, no, that is C-ish for accessing a field of a struct (record) through 
a pointer. It is equivalent to (IIRC) to (^m).packet_id in Pascal (or 
was it (m^).packet_id? Well something like that).

M4
