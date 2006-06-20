From: Patrick McHardy <kaber@trash.net>
Subject: Re: Packet Lost
Date: Tue, 20 Jun 2006 15:51:55 +0200
Message-ID: <4497FD7B.6080008@trash.net>
References: <58963.10.107.26.27.1149788221.squirrel@gpo.iitb.ac.in>
	<4496BADF.5000405@trash.net>	<4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>	<4496FBBB.8090303@trash.net>
	<4873.10.107.26.27.1150781189.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
In-Reply-To: <4873.10.107.26.27.1150781189.squirrel@gpo.iitb.ac.in>
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

Vasantha Kumar Puttappa wrote:
> Hi,
>  Actually I did verified my calculated checksum value with the checksum
> value present in the actual transmitted packet(using ethereal,
> kernel-2.6.11-6), and the values are same.

OK. Then please describe what you're doing in more detail (at what hook
are you queueing, what are you doing to the packet, what is the last
spot you can see the packet, ...). Try to add some LOG rules to see
if the packet really is dropped by ip_queue or later in the stack.
