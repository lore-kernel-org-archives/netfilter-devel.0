From: Pablo Neira <pablo@eurodev.net>
Subject: Re: tcp-windows-tracking and 2.6.6
Date: Sat, 15 May 2004 13:41:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A601CE.1070602@eurodev.net>
References: <87hduiez82.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <87hduiez82.fsf@thorr.asgardr.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Daniel,

See
http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015260.html

regards,
Pablo

Daniel 'NebuchadnezzaR' Dehennin wrote:

>Hello,
>
>tcp-windows-tracking do not apply on 2.6.6:
>patching file net/ipv4/netfilter/ip_conntrack_proto_tcp.c
>Hunk #4 FAILED at 712.
>Hunk #5 succeeded at 857 (offset 2 lines).
>Hunk #6 succeeded at 953 (offset 2 lines).
>1 out of 6 hunks FAILED -- saving rejects to file net/ipv4/netfilter/ip_conntrack_proto_tcp.c.rej
>
>It does not look as a trivial fix for me so I let expert resolve the
>problem ;-)
>
>Thanks.
>  
>
