From: Patrick McHardy <kaber@trash.net>
Subject: Re: Packet Lost
Date: Mon, 19 Jun 2006 21:32:11 +0200
Message-ID: <4496FBBB.8090303@trash.net>
References: <58963.10.107.26.27.1149788221.squirrel@gpo.iitb.ac.in>
	<4496BADF.5000405@trash.net>
	<4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vasantha Kumar Puttappa <vasanthakumar@iitb.ac.in>
In-Reply-To: <4921.10.12.25.5.1150745018.squirrel@gpo.iitb.ac.in>
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
>>IIRC some old versions accidentally fixed up broken checksums
>>they received from userspace and this is not done anymore.
>>Do your packets have correct checksums when sent from userspace
>>to the kernel?
>>
> 
> ya my checksum calculation is correct. If my checksum is wrong, it would
> have been detected by tcpdump or ethereal(in 2.6.11-6).

No it wouldn't have been, thats what I'm saying. Old ipq versions
silently fixed broken checksums. Depending on the hook you're queueing
packets at they might get dropped locally if the checksum is corrupt.
