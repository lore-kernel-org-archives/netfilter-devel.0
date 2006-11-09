From: "miguel Angel Vazquez" <mikinho21@gmail.com>
Subject: queue and HTTP
Date: Thu, 9 Nov 2006 11:40:08 +0100
Message-ID: <f015bcab0611090240s39dcff9g4cbd58dfbce9dcf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello mates.

I'm trying to intercept my own HTTP packages in the OUTPUT hook (I
don't want to use sniffers or ethereal). For that reason I've decided
to use the iptables-queue-modules...recently I can get all the
IP-header information using iphdr struct...but now I don't know how to
continue in order to get the INFO (HTTP packet).

Maybe using ethernet structs??mmmm Using these structs I think I can
get MAC information but I don't know if I can obtain the HTTP packet.

Thanks!
