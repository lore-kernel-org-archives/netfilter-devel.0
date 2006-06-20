From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: Re: Packet Lost
Date: Tue, 20 Jun 2006 10:56:29 +0530 (IST)
Message-ID: <4873.10.107.26.27.1150781189.squirrel@gpo.iitb.ac.in>
References: <58963.10.107.26.27.1149788221.squirrel@gpo.iitb.ac.in>   
	<4496BADF.5000405@trash.net>
	<4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>
	<4496FBBB.8090303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4496FBBB.8090303@trash.net>
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

Hi,
 Actually I did verified my calculated checksum value with the checksum
value present in the actual transmitted packet(using ethereal,
kernel-2.6.11-6), and the values are same.

 Here is my checksum code, please let me if something is wrong.

**********************

// To calculate the new check sum
unsigned short ip_sum_calc(unsigned short *addr,int len)
{


  int nleft = len;
  int sum = 0;
  unsigned short *w = addr;
  unsigned short answer = 0;

  while (nleft > 1)
    {
      sum += *w++;
      nleft -= 2;
    }


  if (nleft == 1)
    {
      *(unsigned char *)(&answer) = *(unsigned char *) w;
      sum += answer;
    }
  sum = (sum >> 16) + (sum & 0xffff);
  sum += (sum >> 16);
  answer = ~sum;

  return answer;

}

***********************




> Vasantha Kumar Puttappa wrote:
>>>IIRC some old versions accidentally fixed up broken checksums
>>>they received from userspace and this is not done anymore.
>>>Do your packets have correct checksums when sent from userspace
>>>to the kernel?
>>>
>>
>> ya my checksum calculation is correct. If my checksum is wrong, it would
>> have been detected by tcpdump or ethereal(in 2.6.11-6).
>
> No it wouldn't have been, thats what I'm saying. Old ipq versions
> silently fixed broken checksums. Depending on the hook you're queueing
> packets at they might get dropped locally if the checksum is corrupt.
>
