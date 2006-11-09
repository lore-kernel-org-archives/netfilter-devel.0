From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: queue and HTTP
Date: Thu, 09 Nov 2006 12:14:50 +0100
Message-ID: <45530DAA.6040301@netfilter.org>
References: <f015bcab0611090240s39dcff9g4cbd58dfbce9dcf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: miguel Angel Vazquez <mikinho21@gmail.com>
In-Reply-To: <f015bcab0611090240s39dcff9g4cbd58dfbce9dcf4@mail.gmail.com>
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

miguel Angel Vazquez wrote:
> Hello mates.
> 
> I'm trying to intercept my own HTTP packages in the OUTPUT hook (I
> don't want to use sniffers or ethereal). For that reason I've decided
> to use the iptables-queue-modules...recently I can get all the
> IP-header information using iphdr struct...but now I don't know how to
> continue in order to get the INFO (HTTP packet).

payload_offset = iph->ihl * 4 + tcph->doff * 4

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
