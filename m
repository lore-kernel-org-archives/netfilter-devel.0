From: Chinh Nguyen <cnguyen@certicom.com>
Subject: SHA-2 HMAC support in linux kernel
Date: Fri, 16 Mar 2007 16:25:53 -0500
Message-ID: <45FB0B61.8060809@certicom.com>
References: <45FAF4FE.5000105@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45FAF4FE.5000105@cpsc.ucalgary.ca>
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

I believe that this is the right list for my question. I'm trying to get 
SHA-2 HMAC support working ipsec in linux kernel (I'm configuring via 
pfkey).

First, sha-384 and sha-512 as authentication algorithm always return 
function not support. But I noted that my linux kernel has a sha512 
kernel module (with alias for sha384). Second, sha-256 uses a 12-byte 
hmac (96 bits).

Looking at the source http://lxr.linux.no/source/net/xfrm/xfrm_algo.c, 
it seems to confirm that this is true. In fact, sha-384 and sha-512 are 
not supported at this time and sha-256 is truncated to 96-bit.

However, the following ietf draft, which I believe is very closed to 
ratification (it has already been assigned iana numbers), specifies 
sha-256 to use 128-bits as hmac (page 18): 
http://www.ietf.org/internet-drafts/draft-kelly-ipsec-ciph-sha2-01.txt

sha-384 is 192 bits, and sha-512 is 256 bits.

1. Is adding sha-384 and sha-512 as simple as adding to the aalg_list 
structure? Can this be done for some subsequent kernel release in the 
future?
2. Can the sha-256 be changed to use 128 bits? Or in order to not break 
backward compatibility, another sha-256 hmac algorithm id be used for 
128 bits?

Thanks,

Chinh
