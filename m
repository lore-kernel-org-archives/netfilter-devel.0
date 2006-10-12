From: Alexey Toptygin <alexeyt@freeshell.org>
Subject: Re: new match extension to implement port knocking in one
Date: Thu, 12 Oct 2006 20:41:29 +0000 (UTC)
Message-ID: <Pine.NEB.4.64.0610121956250.24305@otaku.freeshell.org>
References: <cd08d610610111333m4db2ccc3l78dedcc3da060128@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Luis Floreani <lucholaf@gmail.com>
In-Reply-To: <cd08d610610111333m4db2ccc3l78dedcc3da060128@mail.gmail.com>
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

On Wed, 11 Oct 2006, Luis Floreani wrote:

>> If you're interested in port knocking, you might want to read this
>> paper:  http://www.acsac.org/2005/abstracts/156.html  It covers security
>> issues relating to port knocking in detail, and presents an architecture
>> for solving most of them.
>> 
>> Full disclosure:  I wrote that paper.  Feel free to contact me if you
>> have questions.
>> 
>> Rennie deGraaf
>
> In our implementation, for security, we are using the Tumbler protocol, we
> found it simple yet powerful, check it out here:
> http://tumbler.sourceforge.net/.

It seems that Tumbler is not capable of working across NAT, unless the 
client can somehow obtain its public IP address. Also, it relies on clocks 
being synchronized, since authentication will fail if the UTC time in 
minutes is not identical on the client and server. Tumbler is not as 
stealthy as the techniques in Rennie deGraaf's paper, since it uses an 
open UDP port.

Finally, I doubt the cryptographic security of the Tumbler protocol - it 
relies on a SHA256 hash over the UTC time (in minutes), the client's IP 
and the shared secret. Observing a few authentications from the same 
client will give you hashes of strings with known prefixes (time + IP) and 
a fixed suffix (the secret). The insertion of the optional username 
between the time and IP (not at the end as documented) increases security 
slightly by making the pattern known,fixed,known,fixed but I think some 
attacks will still be possible because there are multiple ralated 
plaintexts with no random parts.

 			Alexey
