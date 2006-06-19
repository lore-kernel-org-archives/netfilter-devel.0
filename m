From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: Re: Packet Lost
Date: Tue, 20 Jun 2006 00:53:38 +0530 (IST)
Message-ID: <4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>
References: <58963.10.107.26.27.1149788221.squirrel@gpo.iitb.ac.in>
	<4496BADF.5000405@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4496BADF.5000405@trash.net>
To: "Patrick McHardy" <kaber@trash.net>
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

> Vasantha Kumar Puttappa wrote:
>> Hi,
>>
>>   I am working on a small application using iptables/libipq. In this,
>> the
>> application would capture a specific packets based on the destination IP
>> address. Then I encapsulate this IP packet inside another new IP packet.
>>
>> My problem is that the encapsulation part works fine in
>> kernel-2.6.11-6(mandriva 2005) and IPtables V 1.2.9.
>> (I can capture encapsulated packets using tcpdump at the sender side
>> i.e,
>> packets are being put on to the network)
>>
>>
>> But this doesn't work in kernel-2.6.12-12 and IPtables-1.3.5
>> (even though there are no erros after callig ipq_set_verdict, the
>> packets
>> are not being put on to the channel. The packets are getting lost after
>> the call to ipq_set_verdict)
>>
>> please let me know if you need more information
>
> IIRC some old versions accidentally fixed up broken checksums
> they received from userspace and this is not done anymore.
> Do your packets have correct checksums when sent from userspace
> to the kernel?
>
>


ya my checksum calculation is correct. If my checksum is wrong, it would
have been detected by tcpdump or ethereal(in 2.6.11-6).

Any suggestions ?
