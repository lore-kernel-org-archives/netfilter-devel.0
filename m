From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Userspace queuing
Date: Tue, 29 Jun 2004 12:18:00 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406290918.i5T9IfMX028725@madinah.ccse.kfupm.edu.sa>
References: <20040628171625.GB32388@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Ulysses Almeida'" <munky@maluco.com.br>
In-Reply-To: <20040628171625.GB32388@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

What I understand from the examples is that I have to create my own
structure for my packet's application header. And then extract the payload
using this approach:

ipq_packet_msg_t *m = ipq_get_packet(buf);
struct iphdr *iph = ((struct iphdr *)m->payload);

where struct iphdr will be struct "myhdr"

and then decide queuing policy according to what I get.

Am I on the right track?
Regards,

-----Original Message-----
From: Ulysses Almeida [mailto:munky@maluco.com.br] 
Sent: Monday, June 28, 2004 8:16 PM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: Re: Userspace queuing

Sorry, I forgot the link http://www.glug.ucdb.br/~ulysses/libipq.html

  Regards

On Mon, Jun 28, 2004 at 10:17:21AM +0300, Muhammad R. Sami wrote:
> Thanks Henrik for your help, I have 2 questions, first of all I could not
> find anyway to extract and read packet payload through libipq, I know it
has
> a function to do so but how to use it (any examples??) and secondly is
there
> any implementation of priority queues (multiple FIFOs) at userspace using
> libipq. If you can help me on these, I would be thankful. 
> Regards,
> 
> 
> 

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
