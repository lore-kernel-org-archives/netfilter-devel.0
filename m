Received: from sonic316-23.consmr.mail.ne1.yahoo.com (sonic316-23.consmr.mail.ne1.yahoo.com [66.163.187.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2B6273D91
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Jul 2025 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.187.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752163942; cv=none; b=jfTK5vzvMZcGY+ISfHFiTxFUiAqeZud/J4s/ZKmpsYGvoBEtU8WnuHEHrs4qYEbDw1przqpTuUbLvgpdUkbhbWgL0X023/equM3a80BbzxVhSlSEoWrgTX85ukZXx33tCNruSGPDsCHFSY1/qlJGabWgdZ3rt7XiFvDyr3c2U3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752163942; c=relaxed/simple;
	bh=XFDhcou09pvznFPyrCm/1OlwNlqpk8zme0te+EB4oBs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:
	 References; b=k3sVR+qOpYmaN8pK6/b9FK2ouhm4cboVEsQBfhV8PnFL6prZ/J5csbfzNgDVtj7PzqHya5ktu3ugbZpAHfjfChC+hmEsVM9PqQet6dfHDStItiJUBFfog4XtUtyZS3OL2BkcGSWCsSU9bdf4vre6S/aznpsI6yI7oIDPo7xWOV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sbcglobal.net; spf=pass smtp.mailfrom=sbcglobal.net; dkim=pass (2048-bit key) header.d=sbcglobal.net header.i=@sbcglobal.net header.b=B8bqqLp8; arc=none smtp.client-ip=66.163.187.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sbcglobal.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sbcglobal.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sbcglobal.net header.i=@sbcglobal.net header.b="B8bqqLp8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sbcglobal.net; s=s2048; t=1752163939; bh=ow77Cg0QUK9dzwXWo2fXPYuIrzUfxeD5gvCHOq327Gg=; h=Date:To:From:Subject:References:From:Subject:Reply-To; b=B8bqqLp8TRDTiqftxsf/r8NTof9BO58PIMzrTx2vGxLZ6/qzpPfCzMRvkaEHcuoVT1fJZb0RqIz9JLXtk/uFI0Y4jXVjhMPR5Js8I+d1p5apP0ONr3mKe+8ORa4avPZUJmQywwBDbvVs7sAtxa0nVzj1vEtZ4NG3QzI2CIcIhYhKWrEP+svhSv5MyFVPc6fxG7Z+SlLMeDmQos8DufFsPxZXRHfb4W2Lx2Mmi9FmbZNscjkjeDz3firvIlfqN2DvJSablt+S1FcCTRyVgf2Yuj9I4C7MUiqAQQEGgbj4a15D1oiz1/2XPSeR1f0gL9bybybKK4r8+/BhL29fdVBKgQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1752163939; bh=4cFbND9KGXy1OAfFCA7iDYbVSuKyd624vH3F87nndha=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=tz7bonGD5+Dzk5jBSX+yF1u1JHTqjVKTget1m4jgq5+xn06jnN8pd0EGeGVY/WCf2NDUIHDHcCg9RytUcr6w8Fovq/DlKgiNVSDg2taD3iPrn6zadc2gkOK6p+Nw0AdI8b28xmTO5OKzVPjhVbwdDzmYJ3Z6SJb+uV8FV/STZy0cLR4U/EziJNuiTg9gIMryJubS3cLSNq1b5YX2i4Z47MuHU+7TOGeWNlKxQ1CdHZvmP2s7Y0hLuIbe4xbAYx34sh9dtqiqvUpXSkJDadlNFAk6KVvWT5/0pDchhIUoqy5vNblz15JMPmKt4/jWmWL9YHokXESZmnccDkpMzrQHHg==
X-YMail-OSG: JOpGJL4VM1l9vtsHVrj9so5IdLC8QKf3vWyNnEhp6ThEWLax7uBRoe0vfgV1_qM
 uGDLToHgcRYYVSUxB.8yNbI2RPBo_oX5Nze0_8tV4d2QOzOyldvHUgPYNeRIC_0JHcaABuI5X3Da
 ZtZJoiFLW8mtdND6S9WJT0JRkQf725VeIZOtJHG7R5SvGiyON5gCfgH6MQG.bzrSekzNAX7a3nV9
 f.aTtKaVR0VGVwk8_3fnMZpF9j4Dl8r7q6LABtJHwlGDPYsxcoTssLgpwdtxmVLPBMc4TpcPFN0w
 7.usW1AV9H8RiJKp1PHpipOwlFp86_Va5V5lVSlxX2c0QNH8Kjimxo2Is4FP1ocIBzsmhKBNjDY4
 0tqoPMetIBsosnO22sUzXlPEtaLrCX4pWUupwdnjEVDWFfabmNqDDcFg1D8zDgk1Mn7YPsfxG9A5
 TrmlLObhitB5mI0N8zbUs6mnpXpFg0x.7loGqUkqlRv0yL2eO1dzZqMfv2bP8U1W1qxMlaOfmWfU
 mr27dJId5YxSLxreqq0E7cdjgxhvexICLLKZOdDx.cX4CeQGPK5hOfiHNwUgCmZGzUy_INaa0GV0
 uIgVCQZbc1WY7RNnBo0zhDPmQbqSrePYe2VcT.rIwOROreHm8rZI4tLTgfM63xc3dHD5E7xx9Ee6
 7xcmYAJ5MMx7IrWe3WibV5.AJeqSTUrQuRaJ_eKAGaQU6chBeysCkYXFfsAmtmhbVLh0Z7PlAsR4
 KueE36HIA3Hzh11fn2Bau40mCSCvieb7bhUj9I6zOfsXENh957M6Uug4_qwPoF5L0hO.F2.TTv3Z
 6Q5LBzpsTBpdMWCmJ8HQVfo_mNilXhrLoQpXeoXv.p78T_ZSUZLK4j78K.XhSysdKTODjpL752lT
 ejsKUxW_wWh_8Q36cN0iepljhlEaG.8_PPtGe7SP.zm8G8ExfO0B3GJcoWYqBfxezrzSKlpzjhYv
 YGVB35d2rYav7wpGSYRF7lrJk1kigh5N7jZ9Cx9G5Jd7.Fx4yL9go3zjEJ2.XfTCARs7.TrOPd7l
 KicFlI7eV41j1j9lVWLN4dA3vgnZosCJQvXD4OAOipmLE5P9nlSlVDaeTvAqZpisQD5Jyi4ZYudQ
 jGj5FfKFiJBKOlcMqMScPTmR2ejA9LydT03VIoed2RPJbmUnzhd35xjjz520bRUcKfgtZ2AFrXGQ
 uUPwMqn2eW3laXsJUPe490GSJTbUzzILQFFC4yi0doN_k3kJESoQARC7Hpfxdb.xdzxRbGqFBv0r
 EQPmhOnX1H04g9Z0N9bZ4dTtMGEBJA5slO81nazjBmu5MHXXNN.syZhG1n5EBlP_Q4sD8i34Ged8
 wMc9KdKHUvN6vVhUBuVFt50Wb6akiPM2WDDL37RDZY_8sWwZrJewsfSAeiamToxtl596yt9An8o2
 aSiydj_4Q9iho2jJfvg957bMZKoKtTlaF.0Xywu4Prd38skJ4DqH0sSwCU1oqXQObQ06uAjD2iuU
 3U.9LX3RpE4JDOByTunMuYj0FFhRp.a.BiyusiWmRgLmO6wvSqWqM2LP70jFV5SgHkYPWVDtjq03
 dwQg3hVJ9c6oW8eO76los5flpT9yTOiomor0jmvY5aF4OZRFajrxWN3.2h14wqGATkzc0Ie0n5ap
 ggjliWxmQZ_yIv4p6cW75iRZPu22iMJROpv2obQNLE8DctA_M2f6qaxfOgzV2jEzoXYE7Y72SaUT
 aY2MMYK5r_VrZhqBsuxO2fg7EIueVotPEGfBobKWyy.cY44ZBvi4egLNFJLk2mgd1ap.4LWH9FJ5
 lsBTD2AS152dyja1VswumSuDfTmPzwjgym4CzZxE_TMl5LxEhTjYl.B0vVkHb1Aandt3PXU6S.tn
 CWwmhnxpsIskOrBq7KILq3LQv1A7du49NriX9.ORSJt0zhYobjidD3iebxxKoFUj52uHn5AKGxnF
 Tz6k6KehgDahCyiDpJ5LRPVjsg8gcqtZ_NqDP71ONiFYfqZ76vw7ZJz7zFR9ZojFFddgHMIMqqWG
 ycGntAWrg2ne62J8PYMVqsYmL_q2.oDbdkmkr8PCHTMzUCTuyhlAEnP4kSFXvIgwucyK.2_kpct_
 Edj9Li9jBDidXTqTSIjNsqLARjBx_fzSTYES3Cu_6FltLLufHDTN1JkObjg9hTSEkfq8_OlaufOy
 AUyjYk7iPsnNX4nQGCSvuDYkduA.BVzBiOTgjXmSSNj3NAjeKcj4r.axJ9e8ArfUAvlD0LpWg9f_
 kEK0PMpgcjCc6_wKhlWwe2DqlSsqdp6Nr.b_ytT_HO9GHhFPY4vlFfQS7qy6wd69x1KC_rrcAXky
 e
X-Sonic-MF: <s.egbert@sbcglobal.net>
X-Sonic-ID: 43cd0594-b7f2-4b5f-8f6c-90c4af94925f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Thu, 10 Jul 2025 16:12:19 +0000
Received: by hermes--production-ne1-9495dc4d7-27szc (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID cf3c17d05e241d32189ba537a65597b5;
          Thu, 10 Jul 2025 16:02:08 +0000 (UTC)
Message-ID: <d4da5872-f209-4517-abae-903143b016f3@sbcglobal.net>
Date: Thu, 10 Jul 2025 11:02:07 -0500
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: netfilter-devel@vger.kernel.org
From: S Egbert <s.egbert@sbcglobal.net>
Subject: add_cmd non-terminal symbol in Bison parser needs to go on a diet
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
References: <d4da5872-f209-4517-abae-903143b016f3.ref@sbcglobal.net>
X-Mailer: WebService/1.1.24149 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

After perusing the entire Netfilter syntax tree in preparation for 
autocompletion, I've made a preliminary analysis that 'add_cmd' 
non-terminal symbol is in need of a reduction into a smaller parser element.

For those needing a diagram, I've posted the XHTML file of Netfilter 
railroad diagram in:

  
https://github.com/egberts/vim-nftables/blob/master/doc/nftables-railroad-chart.xhtml

The railroad chart of Netfilter 'nft' CLI needs to be viewed using a web 
browser as GitHub website doesn't render a standalone XHTML file, but 
you can view it locally and nicely using a 'file:///' in the URL box.


The current 'add_cmd' symbol in Netfilter Bison (src/parser_bison.c) 
comprises of the following required first (1st) token symbols:

   table
   chain
   rule
     ip
     ip6
     inet
     arp
     bridge
     netdev
     <table_id>
   set
   map
   flowtable
   element
   counter
   quota
   ct
   limit
   secmark
   synproxy

The current 'add_cmd' parser is supporting some keywords that the 'nft' 
CLI tool does not support.  This also interferes with any planned 
autocompletion effort.


An updated 'add_cmd' non-terminal symbol could be updated to match the 
current 'nft' CLI tool:

new_add_cmd

   table
   chain
   rule
     ip
     ip6
     inet
     arp
     bridge
     netdev
     <table_id>

What remains unchanged is the 'table_block' element (that is inside the

     table [ <family_spec_explicit> ] <table_id> <chain_id>
         {
             table_block
         };

which would already covered the basic usage with the following starting 
token symbols:

     create
       chain
       rule
         ip
         ip6
         inet
         arp
         bridge
         netdev
         <table_id>
       set
       map
       flowtable
       element
       counter
       quota
       ct
       limit
       secmark
       synproxy

The 'create_cmd' non-terminal symbol would already cover the remaining 
for creation needs of Netfilter:

     create
       table
       chain
       set
       map
       flowtable
       element
       counter
       quota
       ct
       limit
       secmark
       synproxy


This would accelerate ANY autocompletion greatly for our ideal 
multi-context multi-token manner, as well as a JSON outputter.

If the above proves to be ideal, then the true first/starting token list 
would be covered by the 'line' and 'base_cmd' (and otherwise indicated):

   chain
   rule
     ip
     ip6
     inet
     arp
     bridge
     netdev
     <table_identifier>
   replace
   create
   insert
   delete
   get
   list
   reset
   flush
   rename
   import
   export
   monitor
   describe
   destroy
   include (common_block)
   define (common_block)
   redefine (common_block)
   undefine (common_block)
   error (common_block)
   ';' (stmt_separator)
   '\n' (stmt_separator)

Always looking for a better way ...

S Egbert
