From: Fallucchi Antonio <fallucch@cisbic.com>
Subject: Re: Userspace queuing
Date: Tue, 29 Jun 2004 11:08:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40E131A1.3060409@cisbic.com>
References: <Pine.LNX.4.44.0406261535140.16464-100000@filer.marasystems.com> <200406280718.i5S7I1MX005242@madinah.ccse.kfupm.edu.sa> <20040628171625.GB32388@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hi,

i use libipq and "QUEUE" for read the SYN  pachet sent from local 
application...
now I must REDIRECT all packet (width nat) to a local service (proxy).

I have configure the netfilter:

*nat
:PREROUTING ACCEPT [4:240]
:POSTROUTING ACCEPT [22:1306]
:OUTPUT ACCEPT [18:1066]
-A OUTPUT -d ! 127.0.0.1 -p tcp -m tcp --dport 80 ! --tcp-flags SYN SYN 
-j DNAT --to-destination 127.0.0.1:80
-A OUTPUT -d ! 127.0.0.1 -p tcp -m tcp --dport 80 --tcp-flags SYN SYN -j 
QUEUE
COMMIT

or

*nat
:PREROUTING ACCEPT [4:240]
:POSTROUTING ACCEPT [22:1306]
:OUTPUT ACCEPT [18:1066]
-A OUTPUT -d ! 127.0.0.1 -p tcp -m tcp --dport 80 --tcp-flags SYN SYN -j 
QUEUE
-A OUTPUT -d ! 127.0.0.1 -p tcp -m tcp --dport 80 ! --tcp-flags SYN SYN 
-j DNAT --to-destination 127.0.0.1:80
COMMIT

in all the solution the packets bypass the nat rule..
there is other solution ??

Ulysses Almeida wrote:

>Sorry, I forgot the link http://www.glug.ucdb.br/~ulysses/libipq.html
>
>  Regards
>
>On Mon, Jun 28, 2004 at 10:17:21AM +0300, Muhammad R. Sami wrote:
>  
>
>>Thanks Henrik for your help, I have 2 questions, first of all I could not
>>find anyway to extract and read packet payload through libipq, I know it has
>>a function to do so but how to use it (any examples??) and secondly is there
>>any implementation of priority queues (multiple FIFOs) at userspace using
>>libipq. If you can help me on these, I would be thankful. 
>>Regards,
>>
>>
>>
>>    
>>
>
>  
>
