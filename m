From: Richard Bishop <r.j.bishop@ex.ac.uk>
Subject: Re: libipq/payload doubt
Date: Thu, 20 May 2004 03:11:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085019082.40ac13ca71e8e@chloride.lan.uchange.co.uk>
References: <20040519062032.GA32401@maluco.com.br> <1084960972.40ab30cc0af1c@chloride.lan.uchange.co.uk> <20040520000305.GA2227@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20040520000305.GA2227@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-- 
Richard Bishop
Third Year Undergraduate
Department of Computer Science
University of Exeter. UK


Quoting Ulysses Almeida <munky@maluco.com.br>:

>   But, skb->data isn't clear enough on my head. If I queue every packge,
> can I know which type is it? (TCP/UDP/ICMP), just looking for payload?
>   Packet data, can be analyzed on userspace, or maybe changed?

Yep, this is easy stuff :-)

/* If this is an ICMP packet */
if(mess->payload[9]==1) {
	printf("Got an ICMP Packet\n");
}
				
/* If this is a TCP connection: */
if(mess->payload[9]==6) {
	printf("TCP Packet\n");
}
				
/* If this is a UDP connection */
if(mess->payload[9]==17) {
	printf("UDP Connection\n");
}

>   How can i get a payload X-ray?

By 'x-ray' I assume you mean dump the contents of the packet to stdout. 
Behold!:

int x;
	
for (x=0; x<mess->data_len; x++) {
		
	if( (mess->payload[x]&0xff) >= 0x20 && (mess->payload[x]&0xff) <=0x7e) {
			
		printf("%c",mess->payload[x]&0xff);
	}
		
	else {
		printf(".");
	}

}

printf("\n\n");

This will deal with unprintable characters that will otherwise make your life
hell ;-)	

>   When i tried something like printf ("%d\n", tcph->syn); i started to
> recive "passer: Received message truncated: No such file or directory"
> from my program. What is it means?

Erm, sorry, no idea - anybody?

> I think that's it for today! (One day I'll be able to answer
> begginers question, yes I will, I belive in that! ;))

Yep, I'm sure you will be able to. I discovered ipq in about mid April, have
written my undergraduate thesis project using it - and am now answering
questions on how to use it too!

Hope this works for you.


Rich
