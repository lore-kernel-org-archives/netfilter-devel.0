From: Euan de Kock <euan@gekko.co.zw>
Subject: libiptc - Final Clarification
Date: Wed, 08 Oct 2003 12:18:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F83E47E.5060207@gekko.co.zw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have just read through the last years worth of archives, trying to 
find info on using libiptc as an API for developing an app.

 From what I have found...

libiptc is NOT intended to be used as an API, but is for internal use only.

In every archive for this year (and probably every other year), people 
are trying to use libiptc as an API, some succesfully, but most not.

So now my comments...

It is clear that the demand for such an API is high, and the slew of 
apps based around a netfilter API would greatly benefit the entire 
community.

I would like to request that such an API be included in the development 
framework of netfilter. I understand that this will require some work, 
but once done, the standardisation of the API will also simplify future 
enhancements to the core system too.

Please can I elicit some comments on this.

Many Thanks,

Euan de Kock, Ruwa, Zimbabwe.
